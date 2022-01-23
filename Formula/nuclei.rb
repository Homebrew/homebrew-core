class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.9.tar.gz"
  sha256 "b224703e6a5d1f04bdcfccc3ecd488cc847cdab9045dd76c4d4e1d2ab397dd7f"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "170790b5baae3b97eb6c3d6afb387877dfbe2cc19ba06e1a73f9364d0d77668a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9c346ae3c07b035571f3ccfa339d690a021d64ea59098b78c76110673345142"
    sha256 cellar: :any_skip_relocation, monterey:       "f35f8d6857b4f32537c7880d40a1ea92776029dbe3dd2adf27c3d00d0f79cb08"
    sha256 cellar: :any_skip_relocation, big_sur:        "f13642fd61f59ea48d3ee05c157937943ec7463d7d73e395354551ebc1a0d467"
    sha256 cellar: :any_skip_relocation, catalina:       "fd32c2cb82a7f1d3d2d98fd75db7cb2f6e0de242b76de908a3f3e49a0237825f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354e978aab24af7b8b4fefd5a06e05b7f92e12ad445f73aabc2be30a000d0d0f"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
