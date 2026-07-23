class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "407ceeb62b2a1f3fb8260bf527f2d61d1079f440e23c8c94a9796791d7edd565"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b75b90725c65fe1349481753e799e337f261ee6258db26d8fe1ea31f17970654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28f33af36aca65b00df57fa07530ce209caf3b8cca07308f00cbb6196a1e220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed12cc7e08f7fa4a1c37642d235b40ce4e9d19f75e28a5b89e4007d0de09ba2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ff19678efaabadf1a834c5a88b40d8e5f733d3c13eed33237bcb3c2ace36b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e4fe2bf70188e205ff791bc4d300e077c2162505fb28c96bd4918c40fc53c12"
    sha256 cellar: :any,                 x86_64_linux:  "7c2b5c1209ae5bb6e458aef523c5f9fe2ddf14848e393e3b5f36e3da09d6cbc0"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end
