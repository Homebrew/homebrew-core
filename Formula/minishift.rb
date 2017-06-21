class Minishift < Formula
  desc "Runs a single-node OpenShift cluster inside a VM"
  homepage "https://minishift.io/"
  url "https://github.com/minishift/minishift/releases/download/v1.1.0/minishift-1.1.0-darwin-amd64.tgz"
  version "1.1.0"
  sha256 "6c516e11c8b69995df76e39100cda98906259ea5f5ceb860cac51a451bc39d0a"

  def install
    bin.install "minishift"
  end

  test do
    assert_equal "minishift v#{version}\n", shell_output("#{bin}/minishift version")
  end
end
