class Omnara < Formula
  desc "Talk to Your AI Agents from Anywhere"
  homepage "https://omnara.com/"
  url "https://registry.npmjs.org/omnara/-/omnara-1.0.11.tgz"
  sha256 "90e11499da3d486d2664428e2c447d015a898e4f7e57d86df3c910b281e6755f"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "66c178aebb9467cbb059d6de2a65b0ab247619342b3488d382b5ad669fd5d013"
    sha256 cellar: :any,                 arm64_sequoia: "fd7f8ace7a470b3d6f7c2ebd1188030fe6136c80146b40afeed5762b76ee481b"
    sha256 cellar: :any,                 arm64_sonoma:  "91b496e396474ef5e2e7ddd8d4318b535453934406141067dfbb5a647e57278a"
    sha256 cellar: :any,                 sonoma:        "0a2c09ae7bd421ae2435af610854d32d8f90100fa69d9bbf0320df1c81e5b9ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc37bf12876ce36dd1fef53c642975fdef1606199808ce61208b26b021645e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf9f2cc5ba393c05624b31e083c21a327e59b9b65a8341e156476b31a898e7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["OMNARA_API_KEY"] = "test"
    assert_match "unauthorized", shell_output("#{bin}/omnara keys personal list 2>&1", 1)
  end
end
