class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "v0.24.0",
      revision: "0bbb3ec9d92665d372d8393ef3036ba7e0c069a4"
  license "Apache-2.0"

  depends_on "bash" => :build
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["TAG"]         = "v#{version}"

    system "./hack/build.sh", "--fast"

    bin.install "kn"
  end

  test do
    system "#{bin}/kn", "service", "create", "foo",
      "--namespace", "bar",
      "--image", "gcr.io/cloudrun/hello",
      "--target", "."

    yaml = File.read(testpath/"bar/ksvc/foo.yaml")
    assert_match("name: foo", yaml)
    assert_match("namespace: bar", yaml)
    assert_match("image: gcr.io/cloudrun/hello", yaml)

    version_output = shell_output("#{bin}/kn version")
    assert_match("Version:      v#{version}", version_output)
    assert_match("Build Date:   ", version_output)
    assert_match("Git Revision: ", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
  end
end
