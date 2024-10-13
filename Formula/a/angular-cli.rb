class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.8.tgz"
  sha256 "41a4ec997a6b013d2491bad11702c08558e8a99b12dc9ab3e20e4055cea12cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be03a42615ee323a6d13931dd9d649b1f378965ae083b184e38acca55b50b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be03a42615ee323a6d13931dd9d649b1f378965ae083b184e38acca55b50b5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3be03a42615ee323a6d13931dd9d649b1f378965ae083b184e38acca55b50b5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd20ff12998c83103e046b4bc117e7c99b2888b6033edac352d5b6a353e0fe33"
    sha256 cellar: :any_skip_relocation, ventura:       "dd20ff12998c83103e046b4bc117e7c99b2888b6033edac352d5b6a353e0fe33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be03a42615ee323a6d13931dd9d649b1f378965ae083b184e38acca55b50b5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
