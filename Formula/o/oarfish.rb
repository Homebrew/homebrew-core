class Oarfish < Formula
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/releases/download/v0.12.0/source.tar.gz"
  sha256 "037f6aabf4943078b9703daf7978f5eb5805e1ada266cdfc378d4edbdb4562d3"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3148f6ccf7184d24d1554602e6c98c5a74958aa70262e0845d74b5c1fb1d71f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4856ee8bcb3799bc683bf2de6a4bd374d564b1d1d29db7427548ca22316ea7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58dd318f98acfabe47db2c8d76fb0673f6028573713fd5e2805c930e7c3f17e5"
    sha256 cellar: :any,                 arm64_linux:       "4a39d6b575da15677af9739f08ddec91c5bab675fde7dde63aed693ec5870818"
    sha256 cellar: :any,                 x86_64_linux:      "42158355141cc230409e54f67e76378b4bf1403df1bc327e9094a754400d3ee9"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # `Cargo.lock` is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oarfish --version")

    cp_r pkgshare/"test_data/SIRV_isoforms_multi-fasta_170612a.fasta", testpath/"test.fasta"
    system bin/"oarfish", "--reads", "test.fasta", "--annotated", "test.fasta",
                          "--seq-tech", "ont-cdna", "--output", "sample"
    assert_path_exists "sample.quant"
  end
end
