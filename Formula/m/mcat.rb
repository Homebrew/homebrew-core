class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "743fc3073328b8a35fefe9f2a72d99fe89b3c6adc2deacddcbff050fb31b0700"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ea16a074b30a836fc17d931b714643c1ca7d366c47a2b7f31bd107cdb7156e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4480add1daedaeded3bc2b57a9ec87da5349e2a4f93f694201aa3365cfb7b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db2cc12ec4007fbdd89224c50037d34a34bb283befaa04317fa6e19688b84fad"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3b479ce2911234eebea83b6be319050f408514511d581ed4a0ea75eab92fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c54dcfbd47ca4712ee4ba89361e3f5b810bc7e2fe85a58fff2c21597fa057f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a53788e71b1ec2c60085b3b490baa49af5a8bfa089afb2936a17f018d5f588af"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
