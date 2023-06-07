class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5632b0430cee850678e0f004427a3eaf6718e4761f9dd337a920d57919ba50b1"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610705968f7889192080804f1cc93e385edea85218dd2872f783d6da2bbedaf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f3292125a5bea4d9670f29242ef4b739c51a413a9c71c3c3ef7008f3181d471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f71bacff1e94b3affb1a88e1404ce43f483345f25ff57efbdbd690397ef267ae"
    sha256 cellar: :any_skip_relocation, ventura:        "5add673b2c6ba58bfb465bbadfce60a385c158787ef1b39f378016a9de7e5bc0"
    sha256 cellar: :any_skip_relocation, monterey:       "417966fcfc0975d38d63ef551fa7a7204608431ec168803d27ce4ccb49ce7401"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1743a7ff11f01638f77603996781d905134d8ef78d00a8a916b4c5a62107adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f47632a55253a5523c3350bf282d1008d1ae5a265877008ae0ad6ead09ce28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgetc.install Dir["config/*.toml"]
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    fork { exec bin/"joshuto", "--path", testpath }

    assert_match "joshuto-#{version}", shell_output(bin/"joshuto --version")
  end
end
