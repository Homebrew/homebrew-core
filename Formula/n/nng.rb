class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a05936a64851809ea4b6d4d96d80f2a1b815ef14d6c4f6dd2c8716bd38dd1822"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f789508482605d3898a720b13ee0dd824ae18cdfce0bf84c2658bd4b9d8c307d"
    sha256 cellar: :any,                 arm64_sonoma:  "cd22208f26b61a5fbac9c6e056bc0363be4ab8ec5edb12da7c3a6a900e64140d"
    sha256 cellar: :any,                 arm64_ventura: "cc1d18cfce4ade76e5ad37f8c1f01762be60458447460b4580240e74d19c2196"
    sha256 cellar: :any,                 sonoma:        "df7377f8a991aa85c06cef8cca79f2c3d6b2a5d788731ae7e383c9b49d763d62"
    sha256 cellar: :any,                 ventura:       "1c9e50f925a44ed332d98420c2e3c12538336d175896e2fca83f04d809cbf6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627182101a9a3e1288114a3156f64dc01ce0b010d6e26ed144208ff9c59b1f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69fc95eeee497679a4e5914bb9cdf0f43aa5cd30418f89cb562c896420b919b"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
