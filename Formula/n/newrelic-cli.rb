class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.4.tar.gz"
  sha256 "d61226dd4e325bb5d77772ace76c4ba08b2b242f77115f0ddeeee076ed5b6aba"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90a8326fa02989d507d3b4e12039d23e069bce50b9a571dcd919571d47b98706"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e4e75bfeafafbaa597a4df45c537d2b9312ff374631f5216db94ac4ca741ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218c70d89b0fa5ad7f69f44a36d503de2aac3db1ecee46bc8f154336cb3ddbba"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed4ff96b63c08543e67844b88d4d739db76f48bdf2fa39c00bce3748c3a6f2cd"
    sha256 cellar: :any_skip_relocation, ventura:        "df16e0a5e609c8b96d479e6d41695e20e666cec3934af89f5e4ef9c83e2223b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f5721cbbe8c27b931079345e27d37f652b73988f08aa2fbddb78cfe409e8c04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d835558cdb2c956e6324ee8e4bdd2f6fe43deee58ee99c974ef1c238a4b687ab"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
