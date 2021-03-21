class N3dr < Formula
  desc "Nexus3 Backup and Recovery tool"
  homepage "https://n3dr.releasesoftwaremoreoften.com/"
  url "https://github.com/030/n3dr/archive/refs/tags/6.0.5.tar.gz"
  sha256 "0b50539ea4d2858ec8a4f6b8f6776a45a634db26b89dce35d5e527305ed8738a"
  license "MIT"
  depends_on "go" => :build

  def install
    mkdir "cmd/n3dr" do
      system "go", "build", "-ldflags", "-X main.Version=refs/tags/#{version}", "-o", "n3dr"
    end
    bin.install "cmd/n3dr/n3dr" => "n3dr"
  end

  test do
    assert_match "n3dr version refs/tags/#{version}",
      shell_output("n3dr --version")
  end
end
