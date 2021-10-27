class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.15.1.tar.gz"
  sha256 "d426b0c55b3445210392fc61cbeefbe8410665bf2725eed9b1becb6c200ffe42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83ef926cf9456ec3410d1638d9343cee72377951c151e9dc554d9ac7e0e265b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "214004a79f09ced2ba15ed70dd171e3928701bc962234adf99c07364a73cc154"
    sha256 cellar: :any_skip_relocation, monterey:       "eea8b53cfc283d7dd1c9138f7d260e55db24f13795940428308a706324dc7b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfd17394b62ed5ae5dede0b439549e919f6411e0db22c43570b70539e6bd718e"
    sha256 cellar: :any_skip_relocation, catalina:       "3d0f6356d4703cfd34b5d5e910a8e294af781ea2ba5efb932282934e41cf4f52"
    sha256 cellar: :any_skip_relocation, mojave:         "9da66644a815cb772799c02e7b1933e57f799f656b1cd718b64ab1b76642e2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084fb81db0dac1917ea2d0f17509b1af17f9b0ab862ad6f5cb5188534d304201"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
