class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3286ea5a4d04134879a88b04332fa885f2228e0e1a15de2d9724b7f523448f5b"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a680d9c6205704c823d32cde9f27a8f78ea339183bf0bbb708200b86bf1f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d21bcdf67d63ff3f9882d88b4efad383b890224ea4ad9c862929f8c35475a02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247ca932adf0d633e14b232984709a6184ac83a02a82365f1349fa4de070bfe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f76842f0d3bdbd68df22b14c7990bc54a18a579f8fdb568d8fa2a3a68c17b449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9150498e51f85a77449cce7a2d2da5cf88d0355206fb20ee6d48695adc238860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df1aec28bd582fc58c7f6187ec5a6e07b995096b1bf378efe64791dda8bbefe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
