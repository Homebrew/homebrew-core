class Bartib < Formula
  desc "Simple timetracker for the command-line"
  homepage "https://github.com/nikolassv/bartib"
  url "https://github.com/nikolassv/bartib/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "29fcfb9fc2a64c11023d4be9904e2c70e49ec1f6c9f8ce4c6ee9d73825d2f6f4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "52b6b03f65e39ab962199f96aad40078bac3c6b13214803724efc8bd3490cbac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9be195bbd5899cb6db9a41856d9b40b47bbcb7d420ccaf4de1e5ca3e3da6937a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42242e50705c778c366ba844a712b7ed298e59515f03bbfe990c59e43372438f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c62668a835b2f7063af07ea743d6ab4ed7935c69643c16d8f774dd1e74efbdf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f3c6550bcafdd59162ba969481e35b11829e1f9a7364b44134c3f5cf1f0f9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "741cc1e4303b22c965b48b659745eb1fffc7189c09424e408ad92bd07bb8aa24"
    sha256 cellar: :any_skip_relocation, ventura:        "b0ae657c86becd8b322873503cf52457afc6ddf51e90b7937db03f1aec103f51"
    sha256 cellar: :any_skip_relocation, monterey:       "3f112d924d8a4d4ea2a92d5e8200364835b126b3110220f3ee20cdc1576bff3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c652215df17112bc66caf38b274458b81c97a6d22ca7b91cf4fbe6ad908d3328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67345dd0da6698d9c95b8ed43a394fa960574f29f3d45fd1d548561d559c34b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    bartib_file = testpath/"activities.bartib"
    touch bartib_file
    ENV["BARTIB_FILE"] = bartib_file

    system bin/"bartib", "start", "-d", "task BrewTest", "-p", "project"
    sleep 2
    system bin/"bartib", "stop"
    expected =<<~EOS.strip
      \e[1mproject.......... <1m\e[0m
          task BrewTest <1m

      \e[1mTotal............ <1m\e[0m
    EOS
    assert_equal expected, shell_output("#{bin}/bartib report").strip
  end
end
