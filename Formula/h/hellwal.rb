class Hellwal < Formula
  desc "Fast, extensible color palette generator"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "f708cbe7326299ac14a9a39869f5a833d58668ec7bbc679fea8b24915b307864"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73c42183853342a619ad62d146619ca992325adbc96a7959f10d3025b70b93bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb34f50c33798fb23e15b178bcff244744199e147b4aadfe8cfb9394d845f3d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b728f3d510f7919680a2ac779e4b148e2fb5b7eea2199202829d0e4894ef985"
    sha256 cellar: :any,                 arm64_linux:       "b52d11f7d04d3482589e1a6a1a1d2ef0f5abb2e1be59deddcf336aac4067c352"
    sha256 cellar: :any,                 x86_64_linux:      "ab5393bf8906a565866ea561ae8166fe8cf11409ec63a5d265e9c0ce7e8cb96d"
  end

  deny_network_access!

  def install
    system "make", "install", "DESTDIR=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hellwal --version")

    (testpath/"hw.theme").write "%% color0  = #282828 %%"
    output = shell_output("#{bin}/hellwal --skip-term-colors -j -t hw.theme 2>&1", 1)
    assert_match "Not enough colors were specified in color palette", output
  end
end
