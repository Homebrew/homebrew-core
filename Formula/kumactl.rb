class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/Kong/kuma.git",
      :tag      => "0.4.0",
      :revision => "a37aaadf84e97fa9e5135c31353b51ba6a2245f3"

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    outpath = srcpath/"build/artifacts-darwin-amd64/kumactl"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl"
      prefix.install_metafiles
      bin.install outpath/"kumactl"
    end
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config"
    assert_match "Error: YAML contains invalid resource: Name field cannot be empty",
    shell_output("#{bin}/kumactl apply -f config 2>&1", 1)
  end
end
