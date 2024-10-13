class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.37.0",
      revision: "819984d4c1a51c8ff2ef6c23944554148ace0752"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0429387f695927eba3b7863d0408896dc2d0f8ae50a0a436fc3b68bdabfa6539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4bd3816aee903cc552aa878b85afd0e9884faf42601177ccd122000a2a7e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1508f9de26a4a4115a8b86b7559cfdb2694ce1448d0c51dbfd2f0480bff43e01"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2a2a4c571e4aeddeeec164867970e79472edf4e17e0c1fca6fcdd1f3fbd6e7"
    sha256 cellar: :any_skip_relocation, ventura:       "92e4fd0e3124c1d326620f2c2273935af036fbcaff097e54d7356fffd64b482d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28dbb6b9367e1ded3dc60637a4c29d758ea1c42901f8aec445d627d39142b16"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    output = shell_output("#{bin}/operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"

      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
