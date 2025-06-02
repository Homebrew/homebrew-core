class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "e3643d8833c3a9170d695fd6c44914342240bd8bd10cfacaeac2633ee0561709"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721b5216c77bfdcd0e63cf7e4eb40b335d1cbf7840b0ff94505c5ca232cac095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "342d7aa1b364d7803738bafd0fa57360a2e582376641da3668e72e4154cdc9e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e6ce55ff99b8e30e2d5ff43daf266957ef188871bc489bc29f5055201cb1dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "918cb5a1f2944d9ac4ca7e26a9b33533116ec2b625fbbe6eeca9528abc022025"
    sha256 cellar: :any_skip_relocation, ventura:       "3a712002a3d0ce448cd6616ef1f2461ea83a1ddd5d4548b238897750cca6155a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3cc28f10592fc02db316bda0e1f3eab14a007c5e54e5327a94b537a7c8cda1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261f24c2bb060e63028aea10b440069b2c914de89bef3af7e2f65394790f89d4"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
