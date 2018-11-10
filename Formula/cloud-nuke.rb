class CloudNuke < Formula
  desc "Clean up your cloud accounts by nuking all resources in it"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.4.tar.gz"
  sha256 "ce2f5caff4db80accc9ceaeef859382135e772dfd08d1bf981e52098512c45f7"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    print buildpath
    ENV["GOPATH"] = buildpath
    cloud_nuke_path = buildpath/"src/github.com/gruntwork-io/cloud-nuke/"
    cloud_nuke_path.install buildpath.children

    cd cloud_nuke_path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}"
      bin.install "cloud-nuke"
    end
  end

  test do
    assert_match "cloud-nuke version 0.1.4", shell_output("#{bin}/cloud-nuke -v ")
  end
end
