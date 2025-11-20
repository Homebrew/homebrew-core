class LibpostalRest < Formula
  desc "REST API for libpostal"
  homepage "https://github.com/johnlonganecker/libpostal-rest"
  url "https://github.com/johnlonganecker/libpostal-rest/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d02d738fe1d8aee034c47ff9e8123e55885fe481f1a6307fbfe286b7b755468d"
  license "MIT"
  head "https://github.com/johnlonganecker/libpostal-rest.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "905fe876b881844842cf56c6e4f5098bc59b23d0b9eee15e70ec7d07953f25df"
    sha256 cellar: :any,                 arm64_sequoia: "fd5d9cfcd9ea16dd5b1990b18ec200eef3de42b32dbcfc71e74d60dc1e77d5ec"
    sha256 cellar: :any,                 arm64_sonoma:  "35f195463499d406f38fd34722108ec532d1a5faa59bae40266efac277d204a7"
    sha256 cellar: :any,                 arm64_ventura: "20db7d2a602976a14915f4f8246950a17aab06fcd2743e0d4dd0cf867df3eb99"
    sha256 cellar: :any,                 sonoma:        "5364b98a31cf0dd48e851bb94be7cccc60f52568d4952b959b9e6a067dd1fd61"
    sha256 cellar: :any,                 ventura:       "bc55976fe713ac4b6eb92c00f7452410c68c6bde7800fef401e077944d8b7453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6c6f1cb64e46da29ede7308c2f9efcdc140f171f23d41cb0d55586f5c8c2b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945be628085aa46d50c62af4014749288db83af578bdd175b648032661adad25"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libpostal"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "json"

    port = free_port
    ENV["LISTEN_PORT"] = port.to_s
    pid = spawn bin/"libpostal-rest"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    command = <<~EOS
      curl --silent --retry 5 --retry-connrefused -X POST -d '{"query": "100 main st buffalo ny"}' http://0.0.0.0:#{port}/parser
    EOS
    expected = [
      {
        "label" => "house_number",
        "value" => "100",
      },
      {
        "label" => "road",
        "value" => "main st",
      },
      {
        "label" => "city",
        "value" => "buffalo",
      },
      {
        "label" => "state",
        "value" => "ny",
      },
    ]

    parsed = JSON.parse shell_output(command)
    assert_equal expected, parsed
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
