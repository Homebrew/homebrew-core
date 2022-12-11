class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/1.10.8.tar.gz"
  sha256 "40bb683b0c0e9c32a448d4ff77789baded14addf5b050236afaf9c2548ba967b"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "createdby: installer", (testpath/".kubefirst").read
    assert_predicate testpath/"logs", :exist?

    output = <<~EOS
      +------------------+--------------------+
      | ADDON NAME       | INSTALLED?         |
      +------------------+--------------------+
      | Addons Available | Supported by       |
      +------------------+--------------------+
      | kusk             | kubeshop/kubefirst |
      +------------------+--------------------+
    EOS
    assert_match output, shell_output("#{bin}/kubefirst addon list")

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
