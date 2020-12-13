class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.2.5.tar.gz"
  sha256 "568e8a586f7a374ec15b57c442e5535ded10b5232da36d1a1692e793ca849faf"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "0157f987a23017c39c7275f99ebb30ef16e701152171ace1535a9b2e100ff943" => :big_sur
    sha256 "168060ab5814e9c3f8fb5234112fee4466d7bcfc58c49254d60765c790128bbf" => :catalina
    sha256 "ab6ccbc785b6a573400378e8f7480296c90fc177aa5f86d45945fded290a00fa" => :mojave
    sha256 "334e1437787e641ce4f80dbc06fbb4368bb87a34e72aa7d4740acf4d8c016a62" => :high_sierra
  end

  depends_on "python3" => :build
  depends_on "rust" => :build

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "rodio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    pid = fork { exec "#{bin}/ncspot -b . -d debug.log 2>&1 >/dev/null" }
    sleep 2
    Process.kill "TERM", pid

    assert_match '[ncspot::config] [TRACE] "./.config"', File.read("debug.log")
  end
end
