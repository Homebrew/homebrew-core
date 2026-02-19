class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://github.com/b1rger/carl"
  url "https://github.com/b1rger/carl/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1399bf0aadc44efb92f76a7eef6158a6a19799fe0aab82946c417b166a95bbfe"
  license "MIT"
  head "https://github.com/b1rger/carl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "251335aec10fb79627aab7eb88a912fcf54f427dbaf5b57800da3475e884b07b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22bb54f69ef59cb2fa7d5cad18c11b2f13c5a27cdd525e4922ea616e5270dde7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9634216e6f64b9f1433116a4b790b166bc12956a2b268dca0d532d40be008c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9e9f3658080e784393f79ebd5da5d95dec09f7510e8aeaf67df8aaaee057449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bcdedcb89f3fb5e7f46553a89e3b059572977fe240d6980f9c9c3239910ec43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81bb73ea2cf38496e2bcc84d9074de0d93a467728a9f80fef7966f73afcd4ba9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end
