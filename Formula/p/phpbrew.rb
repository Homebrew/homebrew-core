class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/2.2.0/phpbrew.phar"
  sha256 "3247b8438888827d068542b2891392e3beffebe122f4955251fa4f9efa0da03d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "992d2b69cb519e50c028fa60a1658e6b3d2845628263d9d82aae34d723cc71fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992d2b69cb519e50c028fa60a1658e6b3d2845628263d9d82aae34d723cc71fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "992d2b69cb519e50c028fa60a1658e6b3d2845628263d9d82aae34d723cc71fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b7ba820f4d4da27b1c33ba46b957cfd3bf05f5ff525e39c495bd7b89917649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992d2b69cb519e50c028fa60a1658e6b3d2845628263d9d82aae34d723cc71fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992d2b69cb519e50c028fa60a1658e6b3d2845628263d9d82aae34d723cc71fd"
  end

  depends_on "php@8.4"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    libexec.install "phpbrew.phar" => "phpbrew"
    (bin/"phpbrew").write <<~PHP
      #!#{Formula["php@8.4"].opt_bin}/php
      <?php require '#{libexec}/phpbrew';
    PHP
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
