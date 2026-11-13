class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.4.0.tar.gz"
  sha256 "7c556f8435d6c75373fc32d06644e4f804a2fe87a40926218477e99a91d0107f"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7850121d510b561832f56b89458467198c5b9e75dbd89959374de5f9791f33c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e792269e84d9fdd1dc819992bb8f854a888975cc0346dcab9264800762cbd80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56a650c20e893f8d89d9ded4d884659cc4d91df1583d6e591bdc1219949fb199"
    sha256 cellar: :any,                 arm64_linux:       "a4a0ce2d2efd3219c0a5c9988a88b46fa985b18300776caac360b4ba99db9027"
    sha256 cellar: :any,                 x86_64_linux:      "fee89ed477a062def6668cd7c0ca6a415855aa24d8ef0abad2004f3cc6a94d19"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15" => :build # For build script
  depends_on "rust" => :build

  # Create missing output directories when packaging the wrapper.
  patch do
    url "https://github.com/BoundaryML/baml/commit/39c90ee562a211994e3a094835af29ddeb0a6e47.patch?full_index=1"
    sha256 "636cd772379cf84f96ded75de12aed24947ef702a5c73cf701444879da9cfad5"
    type :unofficial
    resolves "https://github.com/BoundaryML/baml/pull/5664"
  end

  allow_network_access! :test

  def fetch
    cd "baml_language/crates" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    commit = build.head? ? Utils.git_head : Utils::Git.get_tar_commit_id(cached_download)
    ENV["BAML_GIT_SHA"] = commit
    # Build the pack host from source instead of downloading a release binary.
    %w[baml_cli baml_pack_host].each do |crate|
      system "cargo", "install", *std_cargo_args(
        path: "baml_language/crates/#{crate}",
        root: buildpath/"build",
      )
    end
    system python3, "baml_language/wrapper/build",
                   "--cli", buildpath/"build/bin/baml-cli",
                   "--pack-host", buildpath/"build/bin/baml-pack-host",
                   "--output", bin/"baml", "--no-self-update"
  end

  test do
    ENV["BAML_HOME"] = testpath/"baml-home"
    ENV.delete "BAML_VERSION"

    system bin/"baml", "toolchain", "use", "--global", "canary"
    shell_output("#{bin}/baml run -e 'baml.sys.exit(42)'", 42)
    checksum = (bin/"baml").sha256
    shell_output("#{bin}/baml self update 2>&1", 1)
    assert_equal checksum, (bin/"baml").sha256
  end
end
