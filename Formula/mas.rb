class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.5",
      revision: "9da3c3a1f72271e022f02897ed587f2ce1fcddf3"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "433b94f32da9835c0800975a5f8db08c823c4b8c35077db7e2a9763d700f0fbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "446af97db6bcb0f44d61e7486d7c74d14325002ff9918dba7a7db3045bf8b07c"
    sha256 cellar: :any_skip_relocation, monterey:       "62f08836f3ff705e8b7dd858a5225a0b0bceb39d6bb2340ee469e68ead73a90b"
    sha256 cellar: :any_skip_relocation, big_sur:        "18fd65b45ff112ca5c80a31202688617a22dec56b28bbb93cf4bdb6ed2d73d56"
    sha256 cellar: :any_skip_relocation, catalina:       "29d2d552d09ef893c3560d94a01c2985bb53b2e9499400987ad76c9b50b9f0f9"
  end

  depends_on :macos
  if Hardware::CPU.arm?
    depends_on xcode: ["12.2", :build]
  else
    depends_on xcode: ["12.0", :build]
  end

  def install
    system "script/build"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
