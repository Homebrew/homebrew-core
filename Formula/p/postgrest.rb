class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.3.tar.gz"
  sha256 "52b814cb9255c43d7f59f3be50336ae761e103c7c9b083dc4833d2579dd2abcf"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "eba1e995f952f401c16c7ea727555c2cde35fb099639c3692de26fa6ca2b0ede"
    sha256 cellar: :any,                 arm64_sonoma:   "68a1b201a0396ca4a9332f68f4a1a039c4239e984dbdd23558778809686237cf"
    sha256 cellar: :any,                 arm64_ventura:  "73a1a4b53994141d9a64eac3fccc2d174dd899c5ce1c1140b11840929b9ddc25"
    sha256 cellar: :any,                 arm64_monterey: "d4da709edbc6a334700db58c596495f19690486095c109d175d694346b1c3efc"
    sha256 cellar: :any,                 sonoma:         "3f8f1332d9b871f608427b742e9d41384a829f21b34bdf1a71a05da6067f8c1e"
    sha256 cellar: :any,                 ventura:        "24e0aa645cdb647163b94695315dd0cd93d172aed47159caf43e818dee8649a2"
    sha256 cellar: :any,                 monterey:       "9bc1e3654ec2c4792ca13434f6551af3233d5121db50e1bdfe70c559a041cf5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859074efdeb538c72381300a6a9c9e0454fd0927ef4205dbde0ca6bc69cd60b8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end
