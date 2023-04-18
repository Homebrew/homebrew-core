class Bartib < Formula
  desc "Simple timetracker for the command-line"
  homepage "https://github.com/nikolassv/bartib"
  url "https://github.com/nikolassv/bartib/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "51ee91f0ebcdba8a3e194d1f800aab942d99b1be1241d9d29f85615a89c87e6e"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15996d83f968c926df74e66a89e377a37a14382edda4c1afa477e48b8b45372a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef66c3c27b46728a1d67621d9346c9598bde8c8c55c03dd67f5bc10c50252c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1141518c093053f6b5bbad3ca09abc2c38838e3d221db77057475f6cf39b0a07"
    sha256 cellar: :any_skip_relocation, ventura:        "41d9f2157bc293eb594fa43ce44971e7928e8f1872b06e95f091717b14275d86"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c1cc58be69351e85e2a3f1dfcbd2432a2bf346c7aad5ff84fd3b50af8ca969"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3581eeeebeebf1061930980b9230b8db484b70e83d6784922eb349a5c351504"
    sha256 cellar: :any_skip_relocation, catalina:       "f5d156cbad858dbaff07cabab759b8ccdd83ccf846ae3cf470c913ed9c143713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1eb8567563a520c2931305243a98d5851bfa15c9d3dd6342d33cdc0062a4a9b"
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
      \e[1mproject.......... 0s\e[0m
          task BrewTest 0s

      \e[1mTotal............ 0s\e[0m
    EOS
    assert_equal expected, shell_output(bin/"bartib report").strip
  end
end
