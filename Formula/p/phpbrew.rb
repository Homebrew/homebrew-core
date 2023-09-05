class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/2.1.0/phpbrew.phar"
  sha256 "0f8f55bb31f6680ad3b9703cddb46d9c5186ea67778fc1896b35f44569d9d006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e20e3587cdb7bb9d7c599b3c6c886741175f816e15119342408db805d1040afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20e3587cdb7bb9d7c599b3c6c886741175f816e15119342408db805d1040afc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e20e3587cdb7bb9d7c599b3c6c886741175f816e15119342408db805d1040afc"
    sha256 cellar: :any_skip_relocation, ventura:        "0d565cc6354d5b0a0061356412f79ad79560072774a4bfbc1eb240f80e87c8eb"
    sha256 cellar: :any_skip_relocation, monterey:       "0d565cc6354d5b0a0061356412f79ad79560072774a4bfbc1eb240f80e87c8eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d565cc6354d5b0a0061356412f79ad79560072774a4bfbc1eb240f80e87c8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8a8974f572904d08b66360b914c9198b632e6dcfee59a27e3d0db97aeb1638"
  end

  # TODO: When `php` 8.2+ support is landed, switch back to `php`.
  # https://github.com/phpbrew/phpbrew/blob/#{version}/composer.json#L27
  depends_on "php@8.1"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    # When switched back to `php`, use `bin.install` instead.
    # bin.install "phpbrew.phar" => "phpbrew"

    libexec.install "phpbrew.phar"
    (bin/"phpbrew").write <<~EOS
      #!#{Formula["php@8.1"].opt_bin}/php
      <?php require '#{libexec}/phpbrew.phar';
    EOS
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
