require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.52.tgz"
  sha256 "4132ec8ae379a65b0532bf79d92900bf58428cdd10c51df1092a79334b57e3bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d381a64e9159d6301a29f50d7e5de11781d5efdd7979b7e0feafc6c144dab723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b245fe8e9c1e9a82b162a4fa6e8de74dbbd0703925644c1ac954aa5f6bedbb48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c44ca6ceefa3e70031b6e0a687288e681bb625839acba5f7eeba7ea97dcad1d"
    sha256 cellar: :any_skip_relocation, ventura:        "4a621843d650cae56b160ca5b3e92c5489885f8f636d77d828539469736561e5"
    sha256 cellar: :any_skip_relocation, monterey:       "4e7a75204ab017e645a67ec567bc41ecde16eaf541f1e2e85c343ab4db75e5fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecb8ce127fb305f074484b102b974cf8a91d775bd5da3e999591c09755e3bd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1808b09ddbf384644a3d6f13e25e5a005a9d06ad39720fa933c559a4eeea54a5"
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
