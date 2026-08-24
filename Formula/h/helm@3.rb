class HelmAT3 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.21.4",
      revision: "813176c51bb5c181dbbd7901298ddcc104cd3417"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7c49de425f9b2c8b27e3df46d6da0bb8bba3a47aebb1188a8f227207aed477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31582da7aad9da1e03192e1cc948318a8d9f3758392976039ef100a4accba88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448dfe5078993f9e5742d1bafa92d82bbf092ddb1a40d5e1bddbece447dc4429"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78eb9577ffbdf00e782489756e7e8abe5b1cef0422c6b7ec5808b9eb7c465b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a7aad193b07224724dedf93044ba6d64de009350b635034578bec4325673122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb90c5db86b0ff59818bc8e8b4acdcc08e7913d154af40782c63ab4be95a022"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
