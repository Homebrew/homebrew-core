require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.49.tgz"
  sha256 "8fc38d48a83891f7cb66935ce3f49dbe8d7c8ff11b953e96785639c320f747fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2d11b6c9303a56168fb02a6191e0e5bdcf0e74072fbe62d73987f480022681e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dec273f05dfca473a93bddd4b04baf1996a9cfc7a7329b1330ab9115ba0417a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35c6aed8df7a6d45ce5ad1bf53f02534292267a3d06343404b80f25276741c97"
    sha256 cellar: :any_skip_relocation, ventura:        "07ea9689ddb03bd75342b0d1a85de7e36f8e73714b1efcf44c8d0400ff884826"
    sha256 cellar: :any_skip_relocation, monterey:       "2af4d69f344d84a23049a5cdbcff4e6c120a0bf35acebac16a139f087e895155"
    sha256 cellar: :any_skip_relocation, big_sur:        "48192525fbfb32a76ee0954467f5dfd09189d2c64c0e012d93d67eaca7ed65bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62cf25ece47378461971dd8b0654d2b4056d793636baf1c0cc904baa6169b21"
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
