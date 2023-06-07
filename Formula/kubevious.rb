require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.57.tgz"
  sha256 "bb64b82d95e836fa08a310ab0380d820101cb578bd41420a0defb130da01cef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69c991c6648c618034597b6b0db51c9dfb401c8c265199c38fc2f4e0e06dbb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69c991c6648c618034597b6b0db51c9dfb401c8c265199c38fc2f4e0e06dbb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c69c991c6648c618034597b6b0db51c9dfb401c8c265199c38fc2f4e0e06dbb8"
    sha256 cellar: :any_skip_relocation, ventura:        "e6ad70d3739f05d6ba53034b544c694d5eaa3793051a73e8d6f17d39cd688ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "e6ad70d3739f05d6ba53034b544c694d5eaa3793051a73e8d6f17d39cd688ad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ad70d3739f05d6ba53034b544c694d5eaa3793051a73e8d6f17d39cd688ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69c991c6648c618034597b6b0db51c9dfb401c8c265199c38fc2f4e0e06dbb8"
  end

  depends_on "node@18"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@18"].opt_bin}:$PATH"
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
