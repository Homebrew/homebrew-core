class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.4.tar.gz"
  sha256 "38b14926f974c849fad74b031c25e32bf581974103e7a30ec2b325990fc32334"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b2986430b4cca454357ac8918622b96699c1889b1753420067ba2a4a8cefd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51b1bd82ce6b28f81a21d3dd4fc8e451cc1a11f2434d9e8f55121d233414d43a"
    sha256 cellar: :any_skip_relocation, monterey:       "13104272c82e12d929653c7c736a2d72663ab63642f324ba081d5d7c85960efc"
    sha256 cellar: :any_skip_relocation, big_sur:        "61e21e04eaa32a05b64b00906c02ebe92b561d5eb087ca044e95cc529b500fc3"
    sha256 cellar: :any_skip_relocation, catalina:       "06c64fa31d6e5adcf99fee3f9ed8351adb563404eb8c47bed79e6ba1bf4196f4"
    sha256 cellar: :any_skip_relocation, mojave:         "b658a49385aabd1ee1c7a081873367a5b2aeb12c9ea0804804cedc38b2731c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93b8f2a1a9c577ab5f29dc249da62eb8b7be0674eaec5875c74a50b16975ee2"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["_build/default/lib/proper/ebin", "include"]
  end

  test do
    output = shell_output("erl -noshell -pa #{opt_prefix}/ebin -eval 'io:write(code:which(proper))' -s init stop")
    refute_equal "non_existing", output
  end
end
