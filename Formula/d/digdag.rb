class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://github.com/treasure-data/digdag/releases/download/v0.10.5.1/digdag-0.10.5.1.jar"
  sha256 "4d1337d777bd334c2348e07ebc1795283aa50a2fd3b7d720cba5ee33b5486aa8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3af153565676568e99be6edfa30c63e2729d7c3e0b1c89cad5fbb49550be4ac3"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "digdag-#{version}.jar"
    bin.write_jar_script libexec/"digdag-#{version}.jar", "digdag", java_version: "11"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
    system bin/"digdag", "init", "mydag"
    cd "mydag" do
      system bin/"digdag", "run", "mydag.dig"
    end
  end
end
