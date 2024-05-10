class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "a368adcca9d2767800b28e2f897cfed3df978479f449908d2977e8e47435c153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25e8d55abfbd8e28939d1fe21a4c869f4b878327461c660417a9c07516a4b31c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dcbb426e08dfd8b538da64e110918b39aa5da08b5f76e492b711f077d6ce444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4ea734aef1c23ea254479c75743be60167dc5e5ee679ccf0a150a5b9560268"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f0681a5ddb660b2cda976ed3994426886d5a34f986e5e1944f868e20932207c"
    sha256 cellar: :any_skip_relocation, ventura:        "de4ba484ab04c7623bc78cd4f5ac91b5c653534ddfaf55a352301cafc8f03a13"
    sha256 cellar: :any_skip_relocation, monterey:       "85975616ca7d0eb8c3db9d6eb2afb17b82791c21703d74b5850915e354e15f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c198d697977dcc89f11f70b89876d95239daa42a5a42738b35cc070bd8cf0d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
