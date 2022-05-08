class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/24.0.0.tar.gz"
  sha256 "43682e6b189a84602930b9fb09a87af400359a9e97a4bb8e1119688c53fad9fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf18bb9e9de43f9ce9af576cfe95005ddbb9c00cf177643cf45332519ea4c9c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf18bb9e9de43f9ce9af576cfe95005ddbb9c00cf177643cf45332519ea4c9c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2e73bd277554e06721ed46faa59a3be8f06af40c647e7bd413b9294913bc4280"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e73bd277554e06721ed46faa59a3be8f06af40c647e7bd413b9294913bc4280"
    sha256 cellar: :any_skip_relocation, catalina:       "2e73bd277554e06721ed46faa59a3be8f06af40c647e7bd413b9294913bc4280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c4d6f8998bd703882e0350904748bd6cb7b7f6d17f0bc8ed9b655d9911b831"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
