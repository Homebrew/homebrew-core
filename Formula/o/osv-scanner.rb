class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "35472c072bca6571df8019843c3d2c2c7379160cc2c32fa1fe4c68f86cdd7704"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16c47f14fb532822191c9d5bee870101928273fbab88e190340c96b340ab355e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d0d61874effbde485f5b4bda0481e1707237ec788a80e431314a843b0e358e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95d9a9295755a8d067a0bf0d2cf164e54ba8f08b40bdefa0169da150e641e94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb55208b8bdf7b9f7d4ea00cb79e7a708b67e404b657bc2900aba8b8600188ec"
    sha256 cellar: :any,                 x86_64_linux:      "5d22c06e81022d2adf7450ec7931a410e4697a70765bb5c7323228782192d3a2"
  end

  depends_on "go" => :build

  # Avoid opening the host filesystem root during sandboxed source scans.
  patch do
    url "https://github.com/google/osv-scanner/commit/3acb3df177c53aa6be3e3a611608ed2b405a2bbc.patch?full_index=1"
    sha256 "5336c703db656024d968a5990f55a3ae277e861baf54e0688d25d090107dfc30"
    type :unofficial
    resolves "https://github.com/google/osv-scanner/pull/3269"
  end

  # `test do` block queries api.osv.dev
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    output = shell_output("#{bin}/osv-scanner scan source --no-call-analysis=go --format=json " \
                          "--all-packages --lockfile=#{testpath}/go.mod")
    packages = JSON.parse(output).fetch("results").flat_map { |result| result.fetch("packages") }
    assert_equal [{ "name" => "github.com/BurntSushi/toml", "version" => "1.0.0", "ecosystem" => "Go" }],
                 packages.map { |package| package.fetch("package").slice("name", "version", "ecosystem") }
  end
end
