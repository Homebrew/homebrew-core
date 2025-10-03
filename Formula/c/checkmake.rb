class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/checkmake/checkmake"
  url "https://github.com/checkmake/checkmake/archive/refs/tags/0.2.2.tar.gz"
  sha256 "4e5914f1ee3e5f384d605406f30799bf556a06b9785d5b0e555fd88b43daf19c"
  license "MIT"
  head "https://github.com/checkmake/checkmake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e7fd519185b64fed252c60bd351ec0d1829dec01f8ba15573b0484c3446722e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c64480b72e17320c970baf104cb6c69a2c9aa54365dd66c2a0a97a9ac0a2581d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7140ec560527466720bbd18e7337f47243ce479bac151a7dea0a84f70a8fd9da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d48a73b85de9be214bafa9ab4cf9712cf1934f898d3fc7b3b6160507a788e3b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddd0a9fa6c9c4e9ba3cd4b04986f6f34f55e3787bd6c6e9dde0dee30a577937"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56a6b97b1e5c3dc5b6a589e0d52b526eb2a0529dfce6a9b8a4a85b93a9bd9da3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee0863d4827ecd46eed6829e6142d37abc0d918629bb3700336817cbadb3b203"
    sha256 cellar: :any_skip_relocation, ventura:        "836d536fe0255fc744a2fa630572e54477f8e59ab19006ddfebb09be51fd14c0"
    sha256 cellar: :any_skip_relocation, monterey:       "16692c95f5e36286cfeedfe914b239200d428b7ed64c1ae61c931c1568dcdbdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8f88660a76082b44e64c8485238aaf46d5e18575ea11ce47c93a2466af24bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f014f3713165ff2f13b59b28db7d7a7672d57b12514284477372bd097dea574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920aea0127e9224ec538e4c4f1f1e4fafec0f6e10610687e60c20d053cc02f0e"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    sh = testpath/"Makefile"
    sh.write <<~EOS
      clean:
      \trm bar
      \trm foo

      foo: bar
      \ttouch foo

      bar:
      \ttouch bar

      all: foo

      test:
      \t@echo test

      .PHONY: clean test
    EOS
    assert_match "phonydeclared", shell_output("#{bin}/checkmake #{sh}", 2)
  end
end
