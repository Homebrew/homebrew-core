class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f3eb60db36fe59655e13dabad8612cd9fa1b669c4a0c5c29c9bfe88b7c045db8"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ee21e554305b7a042dbf101da7f06f891cf794d8ad95a848eae04da4d18f64c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc838c20186e9caf4152f41e7bfaa28e275e72b5d0774616484269c20ad41a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad2dcb7b372519a9daa1451316312a52769772f3a2c25a2d89377aab6b3750fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "880444ed5cd9bdabd36eaa8749f7405591e8cf1c5b2ec86373df3869b25f13f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "21948620a920e604f3cc86ba3bbd73a9e4354a8a481e6d4c674e1d4478caf994"
    sha256 cellar: :any_skip_relocation, ventura:        "9125044764b6089bfd9d94ac15a38c3c0fd7b457b6e374b6b8331145e966ad8a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c1e3717c206c9b95a8ffe93d8123758189744501eadbbbd26464b8c3876b39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1571b0a3d2285df40f15726d8f0dd3ca62f4f9a33d3779b19211f2570f9f95c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
