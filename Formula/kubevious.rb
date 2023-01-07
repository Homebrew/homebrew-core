require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.51.tgz"
  sha256 "5163aef46bdc665c8d0fb17dd3b231bf3108552ba5799e2fac4f1481065707d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f6a059d461507a1e89ee54fa64062df51dec8caba13db9f12cada7423eb265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d6098f7d58764d221971d14a53e1e70e27f63bbe6085681db7e1f185507efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c97b0b94ad3276078945b863c2913fd1afb0841f45ea04b98647c4aa4a405774"
    sha256 cellar: :any_skip_relocation, ventura:        "40895775e5abdc340073956a95e3c4f76554bfd19cdf5bbc7883ff95754a258f"
    sha256 cellar: :any_skip_relocation, monterey:       "46958cd5981466fabb5420296671508e8cb8a05398816eda0011c0ee15f9b6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "d342abc08e030c28103802c7b651ce6ed3aa7c523aa378bf0360eeae63db218e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04eab87615b081ab4f04d83ce83afddfc2babf5f05d05ed7120c1132288cd6d5"
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
