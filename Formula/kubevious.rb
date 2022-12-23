require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.45.tgz"
  sha256 "2d8d1efd0d289fbfa5643cd42b9fe58d2addbc9f8385e02eeab80519ea48bafa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaeacad98ccd30cb2f2eb8fb877d2104ffd0bcee5522841e72c05977ed5b96f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0e2139e9c545355b3b5b37d52b1d94182b5dd1800ebbb4f3d6b3b3cf1daa90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25411ab108aa461654d15e92b281891e08226e83a5860e0de7a8e2dd06db2ee3"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9ec213d06cfa4b970b4838edfcc8396d1496c74d500d92427bef08f78aa1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "77e0b367a7d1ed0c58f49b89e4d13f02de342df71b803d434e9606072f89f70e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63f372fa62ce9999778b7437ca0c966793ca169b64798eb04e4516155430f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338b55995b58d735f39bb392a5d0593850e6ec4b2baa0d1dca888903b2911fef"
  end

  # upstream issue to track node@18 support
  # https://github.com/kubevious/cli/issues/8
  depends_on "node@14"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: BadDeployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~EOF
      apiVersion: v1
      kind: Service
      metadata:
        labels:
          app: nginx
        name: nginx
      spec:
        type: ClusterIP
        ports:
        - name: http
          port: 80
          targetPort: 8080
        selector:
          app: nginx
    EOF

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end
