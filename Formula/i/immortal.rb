class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/refs/tags/v0.24.7.tar.gz"
  sha256 "f4e646bda8ed8124271f002ceefea4949fcb8d70e2ec55856641b4be8cf69c51"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26861092dde978f27339910033364f10dd3161087633aa496060bd8fa34fae36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26861092dde978f27339910033364f10dd3161087633aa496060bd8fa34fae36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26861092dde978f27339910033364f10dd3161087633aa496060bd8fa34fae36"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a0ba97dc777bd0c4b1183fcccc14f65385a18f266909d20392123e2930fe56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bceeb82570bd18ecfcb167e1ab8343c24e19fca659f9c61a21b75067b1503e4d"
    sha256 cellar: :any,                 x86_64_linux:  "a6e52a13abf90702e0aa1f613f6235ac29eca8c3ee8688d117fc192689780632"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[immortal immortalctl immortaldir].each do |file|
      system "go", "build", *std_go_args(ldflags:, output: bin/file), "cmd/#{file}/main.go"
    end
    man8.install Dir["man/*.8"]
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
