require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/kubevious"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.30.tgz"
  sha256 "5b75d9ed13ee4159892dd72ef5eb24dc40e5f9696b5dea8c581c72b4fce213be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68948558b072c8e36c2a81082a1178fe272409f2f4f2bed7008c887977d36697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89641f73698168d3c8100d2e7ed1e1aa71391d7af4e4011689bae3bf8228daac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce9d98828bab3756d723fbde65e1c693c02eecf940c3f8ed8722fb6c1b26657b"
    sha256 cellar: :any_skip_relocation, ventura:        "613b3738ec657e7d45b2361ac817228c6461db5c3910779752ec2d062942b716"
    sha256 cellar: :any_skip_relocation, monterey:       "5efbb79420b9cf602339e6f4cfef0fdf876574f9fde4410cb07f41548fb2ef3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfd27256f1c75c9948416ee54b8238eb0c32959c31eae7661a1f2c850adfc0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb7a4a0a04b689d6ecdec5b2a55fbebff968b003a4b22cfdd2a848446c35e98"
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
