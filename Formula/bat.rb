class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.22.1.tar.gz"
  sha256 "25e45debf7c86794281d63a51564feefa96fdfdf575381e3adc5c06653ecaeca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ca10d2732acc1ea598f366f57b13354700def18a170307b8a80c1252badd05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01aeb3e1ede73d04f64213e670127511eb50153875ffb5a8f708e7b7b56638fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e001f7da90ae6ff14ac240c79f8c781d0f9d92f8ae05b1993c233eeb5cbc3945"
    sha256 cellar: :any_skip_relocation, ventura:        "d3145741d524d8bf12775263a7a376b8aa82b566719b953a429f4ab1c6b433bc"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ad09d3eba478b679c9666ea7bd8f7a5732273abba93d0a897af3d6020cd495"
    sha256 cellar: :any_skip_relocation, big_sur:        "118c45fc332fa36bf87b9d6edd460d6ba9e69292b8eab47afe2d99e1db1e5bfb"
    sha256 cellar: :any_skip_relocation, catalina:       "5bb11d651efbd6f854a9eaf96367ce46c78ad4232b11bae9835a5e21c56dbdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6064e029a93bbdf8ba005d419cce9640c3a28b7c25cd1774c55580f1bb8d3faa"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
