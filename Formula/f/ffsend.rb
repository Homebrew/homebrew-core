class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/refs/tags/v0.2.77.tar.gz"
  sha256 "b13329704c5eab7c74ebc29c3f2209290ea00e758139daaefc0ab0d5728c2fa4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77cae62ecbbd3f434c1d50b40ac1f7fb281ea070d2afecf5751d2d1e7694735b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d60f43b2fdb056059608e05dd6e4e9f1fad57486180c3732a40ffaaa440116d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98551254d908b6fa9496bfd9281fb359c7fdc34b9d172db68d1fa633d8c67f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "398d00de4d062551f33c186bdb932c9ae62847f5e0a594663d4d09886ecbcc69"
    sha256 cellar: :any_skip_relocation, sonoma:        "58610267085cd19c5445172c1f59662c58b840b6ac3bcc4da04a8598ba222f6a"
    sha256 cellar: :any_skip_relocation, ventura:       "f4784a7c6f31e7e0ab55e1c44095c84ab20544a05211c20b212e14daaf143e13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57499a24df5e2e1f1042b40d7d81fc7257af612d36e593516935d6a768a560ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2800da04659f26aacbd7ca4619fa0a06762cc5ef0c652630c139881f64c5aeba"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  # rust 1.87.0 patch, upstream pr ref, https://gitlab.com/timvisee/ffsend/-/merge_requests/44
  patch do
    url "https://gitlab.com/timvisee/ffsend/-/commit/29eb167d4367929a2546c20b3f2bbf890b63c631.diff"
    sha256 "e5171b23ffd3cc0f4f1d47b29d110735c211ce96ba601a166a66537df28ed1c4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash" => "ffsend"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system bin/"ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
