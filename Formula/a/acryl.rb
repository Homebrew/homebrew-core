class Acryl < Formula
  desc "Build agentic apps from plugins: ACRYL Control Center and its launcher"
  homepage "https://acryl.dev"
  url "https://registry.npmjs.org/acryl/-/acryl-0.3.9.tgz"
  sha256 "33d6bdf5a18d70c4b1a9dc77a0fa742c746918c31a831dbaf3cc6d52d39ab39e"
  license "MIT"

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/acryl --version")

    # The app list starts empty, takes an app folder (one with a blend.yaml) and lists it with its Blend id.
    assert_match "No apps yet", shell_output("#{bin}/acryl apps")
    (testpath/"myapp/blend.yaml").write <<~YAML
      apiVersion: blends.acryl.dev/v1alpha1
      kind: Blueprint
      metadata:
        id: brew.test
        name: Brew Test
        version: 0.1.0
    YAML
    assert_match "Added myapp", shell_output("#{bin}/acryl apps add #{testpath}/myapp")
    assert_match(/myapp\s+ready\s+brew\.test/, shell_output("#{bin}/acryl apps"))
    assert_path_exists testpath/".acryl/control-center-apps.json"
  end
end
