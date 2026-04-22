class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.1.4",
      revision: "05fa37973dc9e42b76e1d2883494c87174b6074f"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f04ffbbdfd6ab2a148543cbb6f18e226cbc94bc0148598335a5ca8fe33be88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f7bcba75c2a04a833306380879595cf444ac159e78885d361b25219875a036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eac69d197bb7d6275c1ecddd18b9fe6a7506642a68c5b7f0c8e9d0050697685"
    sha256 cellar: :any_skip_relocation, sonoma:        "b98cc2cccb8d065e8b408bb4caaea575710012de96f8bd852caa4d2730a984fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed00978b0c220ff4c77a02169d0833da4bbdf591b8afdb4ee611cabe6e971d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d73dbe4c18a12df4316b0cf5e6f6cd649d125110ed53bc74289322346006de9"
  end

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
