class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "1a25bbf9a9016651fc332eecc02bb9681d0b8e722c2e256e73ddb88fbce6e6b0"
  license "Apache-2.0"
  compatibility_version 4
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73669ada0da76a46cd1f6cb803a2d9a2bdd6984973b92b71de62a904da9c57e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2998c4caa20ee100a5326257c1ef179038ead0c63a27db75f0cdb5ddeea1d66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5adba195b1fc670f08fd2a3014d367178ae20cce0dc0d40675074ea432bf2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "676fdd0abc7cb992f143239ae844693fa92d3504bd76d96f8af815f4997b6225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46998dd0611cef4b28d5c79f982bb370b456b73b01ff39cf4bc823cca57d2b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef588ecd35dcb724fe1d055fe02f11534c3ec4386a37367ce18278fd98737a8"
  end

  depends_on "erlang"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end
