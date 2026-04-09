class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.12.2.tar.gz"
  sha256 "d22a811f0f43a81f6c8fef69df4df6fda9efa8845d60f004e8d4facdd37a5283"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4bf293406a78e70ec6aa8664dbf07873fa6882ff63af62db3ebc5cc2ac4640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a6845a24088b506357e21b4940e679128b08738add5e30327506ec4bb62055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925453909fecb7b0af46a20a73567a3f6473408b92fb6ed45537159f8433a62b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e715e622ca049773532373028d8b638de47409ba4cdb40883f320f863bafc711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275fff9eb8dc83e02f90bf957343e7046a250948611b627d5c4a2887ab039eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064a12a0eb68ee1a7f4c8b7e87b1bc16ddf1241f41d53a2b4e157a8d4ca7c30e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
