class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "120935c7e98f9b64488fde39987154a6a5b2236cb65ae847917012adf5e122d1"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24da4584b7d539fe43d4a9bc0b685ca163098415ffcddd6498222d4f94878b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f163dc5b5f3d5d4f6aad560a96d3a8997c98083e062eac8136aa27d844fec65b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f7ad3497b4db2afca045c3434cfc3e35acf17f70f668d4fd507de802b8dee04"
    sha256 cellar: :any_skip_relocation, sonoma:        "79225362c0448dd2843651be28b9e57060f37087a77db5fffc8db3f3f84c26d4"
    sha256 cellar: :any_skip_relocation, ventura:       "c045403b8d14a78e2f5305832c33ff4d88d0f85e2752776640857a301b0f1912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15edeee954289721ebb15f60c1346e7b89a579527e4fed32f9caf66b1e7b7379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ecd9a9aee174a461e3b57e6e0ebcb4098fedf788a95eae69bdb03f00f6529d"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash" => "lsd"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
    pwsh_completion.install "_lsd.ps1"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
