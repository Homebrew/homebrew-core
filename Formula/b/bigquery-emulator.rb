class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "b33ef3823dd314ffbf4d33d3ffb314375cc6e78e025938243a81d191ed424e19"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "919fa60a9b37169b517f7577df3ac88a3399bc6371810187cf000ae13bfa5556"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030bc76fb03c2e4d758b945ef1512f82017a38b3d009a46775b7d3640d8e3c57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a3bf86de58dde0912ecd37af31fc657dac5a1ab2588ae27686d254dd38b934"
    sha256 cellar: :any_skip_relocation, sonoma:         "a63ccc4a6de2319e88b6f74c6b5fa1da3d59c773ff3bf54d5b61085bb66571ba"
    sha256 cellar: :any_skip_relocation, ventura:        "33c4d4fcd8961ea40893c05190ea753de280bc5ff35153a49caf0eb07fd3391b"
    sha256 cellar: :any_skip_relocation, monterey:       "6f63e4a07dfddc0a408dcf5aa1e106b86e36c5eba548f5550122b00af429a436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbbacfb90b781068c6b9c2ee71c330f19f1ceb5487a8b2e9ea3d9c453abc08fd"
  end

  # use "go" again after https://github.com/goccy/bigquery-emulator/issues/348 is fixed and released
  depends_on "go@1.22" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=#{version} -X main.revision=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    port = free_port

    fork do
      exec bin/"bigquery-emulator", "--project=test", "--port=#{port}"
    end

    sleep 5
    system "nc", "-z", "localhost", port.to_s

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  end
end
