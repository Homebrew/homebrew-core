class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.1.1",
      revision: "5caf0044d4ef3d62a955440272999e139aafbbed"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ec266bf5667bdbc8d5a5878e54ce6c604dbd7cbc260e8f6452e2b820a16e737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9438e7aef0568e0c75ff421a89b29aa54c7501d6900a27746d4d808b9c7e854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7551583f57c5a39ca0ec9821f70ccda9fa864dcf2a95bc06dcb7632015429a61"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6e63ef368835b1a57db34faf9d890eb8c5f8f27f74c129f6b647b96536f8071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214fa8e3dbd0549bf98dbb81e22dd0a250c5e6d10ead046f1e7bf32432743d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9cd6c8eafc109065c7b532f0b6741677869115aff06fcc067bdf4aa507892b"
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
