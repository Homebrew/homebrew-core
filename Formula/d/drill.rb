class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/refs/tags/0.8.3.tar.gz"
  sha256 "12096bfeb57fa567f9104615c872b5fec787bacf5b9efcc9f14d496c08efe30d"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d39673bb52832f8c4cf3e962faa018890e29b1be4ecbc17416ab3a6492efd0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78f816fcac6826ac580286234ae1ba73cd4beb0b2862a7a523fb36b56863414f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339d49f914baa6c8493f438e6c68b87ea51bdbb3dceca074c9e6fafbb207b728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a63152d9bd25cb84099584ce2668b02c714225c5cc2d5e6816198d857e02663"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "518b086f2c1ae00f3d677615e2455a45b36976920a949a329dd1ec6a80cbd35b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea7da74e8e531c20cb687722ed6cf5b4ea21ebad2cae0b518e6512a2c78474b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b71f3a574580dd32d8c71952387cae4c892d57e85db59733c12e2529722ca034"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9b9f7b85d1962bb691648e99a4096fecc8c10f59844bc73db1bd93a77f7c99"
    sha256 cellar: :any_skip_relocation, monterey:       "051d29acc8b70771b3f1510942cca546668921ddf12b66ed25ec7c95790bf5f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "61eadba6d4008eeb229a2ef431a6977fbaa19cb489e54f55d125edfaab016fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "17b7a2370d35c2fcd3056cc02deb5f5016bfb5282ed9cc86c99e05343f548b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701f7a9ab685f50091ce4c85d09cffde2a6b46ecda5052cdce5a41b06dafffd6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "ldns", because: "both install a `drill` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"benchmark.yml").write <<~YAML
      ---
      concurrency: 4
      base: 'https://dummyjson.com'
      iterations: 5
      rampup: 2

      plan:
        - name: Http status
          request:
            url: /http/200

        - name: Check products API
          request:
            url: /products/1
    YAML

    assert_match "Total requests            10",
      shell_output("#{bin}/drill --benchmark #{testpath}/benchmark.yml --stats")
  end
end
