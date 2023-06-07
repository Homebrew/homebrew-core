class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.24.4.tar.gz"
  sha256 "a343581dbe58fb0faa1c65b233a067820d8d5ecefc9726da5ad3ef979a2a0b08"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98259ae7b58b5c2066ae44ea802b0a513574a7f5850e6b9156621fef9e693409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "516bb39ac0742d272011dd2804b18677d83233717af8233f35f1a81f21f0a7fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2df85d157c9c1c6273dc516619ae18477f2574fe7a67b2145ab040272f4eb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "d3294c861c1cb7a9ace5c8a4692f9df80425b800f678b36735be4e7e4fb1412e"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba02f8783dd2005d344f16484ba9ae1ac1a714330bae6504aeef327b3677383"
    sha256 cellar: :any_skip_relocation, big_sur:        "f621661ecfdba43e97f0c031b5de4577c080307271bbdf813ac69384b486cc33"
    sha256 cellar: :any_skip_relocation, catalina:       "305a72330b69876b658ac5a2d0c9daa0f32c2bd99efd3b837a11345715d21aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f539cf58912b6e954293efd7983d17f9a82670cae7faea1a979bf5c63b5887"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[immortal immortalctl immortaldir].each do |file|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/file), "cmd/#{file}/main.go"
    end
    man8.install Dir["man/*.8"]
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
