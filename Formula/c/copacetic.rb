class Copacetic < Formula
  desc "Tool for patching container images using reports from vulnerability scanners"
  homepage "https://project-copacetic.github.io/copacetic/website/"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a2adaafbed9f6a05b69567b16f0c40d6047ce1e70f9d56c4f78918095e83076b"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"copa")

    generate_completions_from_executable(bin/"copa", "completion", base_name: "copa")
  end

  test do
    touch testpath/"foo.json"
    assert_match "Error: foo.json is not a supported scan report format",
                 shell_output(bin/"copa patch -i images/brew -r foo.json -t brew-patched 2>&1", 1)
  end
end
