class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.27.1.tar.gz"
  sha256 "e77f27b40484922bd1f29802c8b518c4d5515a9485fe4e7da8b488d9e80537f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055ab7e3be1a5b7e8e4a76070c6ad8d8ab8fadbb9f12c8e7edaf2b894d0eb9c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27793fa8c369d76d0dd6f50591a5deecd0e1b0887901ea5f39988da36205ad57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e16f133baab7561b442354abfb5f6fdf4696b2adcbcadbe2c7803f02abff98e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ef056c3ca7f5d6f4a78ca5af1f44a51ab7672bd9aba5fbcea30e28d7df867c"
    sha256 cellar: :any_skip_relocation, ventura:       "510a2fcab8690b73f9ccf952c77414cf8189afef33f348298e96ec14ab43c5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6def9e38b933c65a6913bd40a9efca3803c69e4e7a23eab9adb271c60d08d419"
  end

  depends_on "gradle" => :build
  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system "gradle", "--no-daemon", "-DreleaseBuild=true", job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
