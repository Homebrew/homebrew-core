class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.15.tar.gz"
  sha256 "3edc8ea1551fdf290d6bba721105e2e2c23964070ac18c13b4b8d959cdf6116f"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4be12510b53fae5e4691508dbd9fa95e44df7fc7443d02abfc28c48bf9d933f" => :mojave
    sha256 "3cedd0d563f1993abfb31d9e9ccb5b6126cdc00f255f902f973a450f2bc003b4" => :high_sierra
    sha256 "659d3c92aa69a836f30bec57e3082c1a1666c51ddb84a15553ce2180e2c9eadf" => :sierra
    sha256 "97b65f395b1b0e303b66221573e619ffd518f465ef1cd67bd1c6af7d14928174" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
